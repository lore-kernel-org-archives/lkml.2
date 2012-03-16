Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030813Ab2CPVcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:32:21 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:59221 "EHLO
	homiemail-a59.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751921Ab2CPVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=Af4ffrb1xia5/NBMiGG+ajC6eKQ17IrB+10lxKadnx8ZhLQb8WY/3rdby8LuS
	TOos7BEZicHWItIvwYyh16KqqZydVbH6k8TENBcMCX4GC5yPLSkZ/wtm5DtHw3KG
	o0pEEGFx+cc6PK80tejupjJcHY5slGFtr+Y4lD25fg7UPI=
Message-ID: <4F63B15F.2060001@shealevy.com>
Date: Fri, 16 Mar 2012 17:32:15 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: matt.fleming@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proposal: EFI boot stub configuration file
References: <4F63AFD5.3010607@shealevy.com>
In-Reply-To: <4F63AFD5.3010607@shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/12 5:25 PM, Shea Levy wrote:
> the file would be expected to be in UCS-2 format

Actually, on second thought I could just add a check to see if the 
parent handle is NULL in an else if after the already-existing check to 
see if the command line options are NULL. Then the file can be expected 
to be ASCII.
