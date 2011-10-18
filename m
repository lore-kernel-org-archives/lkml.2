Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1JRQSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:18:00 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:34707 "EHLO
	homiemail-a91.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933002Ab1JRQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=YkqWzpNW+vsDePVxAhPEktZO8s51VD3IsaMyJ2zXiUQnRRb/dUB3sqv2w9k2U
	zg7wsJ4hb7No3zPwsBv0mlCBKGMxZF2VjvvPy5tq0Cch0sTmp0DMSB+Gil1TkzMD
	DkYZT3MfEdqL4ate/gazkunrWRqsyssbq00oLFvLJNfOog=
Message-ID: <4E9DA6B4.2010906@shealevy.com>
Date: Tue, 18 Oct 2011 12:17:56 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 00/26]  New ACL format for better NFSv4 acl interoperability
References: <1318951981-5508-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1318951981-5508-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 11:32 AM, Aneesh Kumar K.V wrote:
> More details regarding richacl can be found at
> http://acl.bestbits.at/richacl/
>
FYI, this site says nfs4acls is the successor project of richacls, but 
from what I can see it is actually the predecessor. Is my understanding 
correct, or is nfs4acls the next-gen product here?

Regards,
Shea Levy
