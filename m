Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2EAAAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:00:34 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:36309 "EHLO
	homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756679Ab2EAAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=Nwus4DEqDVWCp4qZSnXYZ58/bq1aKhv9xQXbIVHTAtK4GSJXkCkh6+TLt++wZ
	IOvn9IQEsM5dv6gkfwV9rn67CgNg1Rmv3aulQkdcVV9IwqxK9CBCGHZg9Dirj2LM
	t4VdLCuWw7Gz+zgWWEWEq7su7rld7dmImRlzr76iuKglDw=
Message-ID: <4F9F279E.606@shealevy.com>
Date: Mon, 30 Apr 2012 20:00:30 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120404 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Validate UEFI boot variables
References: <1335816690-26019-1-git-send-email-mjg@redhat.com> <1335816690-26019-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1335816690-26019-2-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/30/2012 04:11 PM, Matthew Garrett wrote:
> A common flaw in UEFI systems is a refusal to POST triggered by a malformed
> boot variable. Once in this state, machines may only be restored by
> reflashing their firmware with an external hardware device. While this is
> obviously a firmware bug, the serious nature of the outcome suggests that
> operating systems should filter their variable writes in order to prevent
> a malicious user from rendering the machine unusable.

Any chance this will make it safe to use efibootmgr on Apple EFI 
firmware? I've been afraid to use it because I've read it can silently 
brick the device due to a mistake in efibootmgr. Obviously this won't 
correct that mistake, but with this applied should a successful variable 
set imply that the firmware wasn't bricked?

Cheers,
Shea Levy
