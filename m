Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1DMSbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:31:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47086 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab1DMSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u3nZoXDG20PdGsbGRKPK1HEwYeHACrJuxNzH/3/BDVuqPKrJjeqlUpa+PhIzz71t8H
         oKkMKQ7TArm40iwCCHLSI6DLlT70udL01oH1KYHmFftv83iTtvXgUc3VYx8aj8BRIYyr
         Erk6FtSUzjinU+MZJev++pPn95sWbTp5d04LY=
Message-ID: <4DA5EBEC.10807@gmail.com>
Date: Wed, 13 Apr 2011 14:31:08 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Secure file deletion option question
References: <4DA5E20E.4070904@gmail.com>
In-Reply-To: <4DA5E20E.4070904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 01:49 PM, Marco Stornelli wrote:
> Hi all,
>
> I don't see any fs implements that feature. The flag FS_SECRM_FL seems never 
> used with the exception of some define in some fs. Is there a motivation for 
> this? It seems a good option to me.
>
> Marco

I think that most secure deletion code is done from user space, which can deal 
with odd storage types and so on. Just deleting and overwriting the blocks with 
zero data is not sufficient for some needs.

Having user space tools deal with the myriad of ways that it could be done keeps 
the policy out of the kernel...

Ric

