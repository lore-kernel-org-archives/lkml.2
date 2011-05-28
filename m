Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1E1JOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 05:14:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51170 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1E1JOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 05:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iJry+KnJkmWWPqKaZrYM8t4ivicdOiO+nP1+CLg3Rq0aiqOFF3bJaUYjSi6kEQZce3
         CNmttUaqUzcYeqcb+h6JqDtrI5BF1vQ6lRkm55pJjJemPpTLuQRSg6Ex6ZGvVrqoqvHI
         qWSy/1eJu5f9W2gkGrYNhmzdydpaIrkup1pXI=
Message-ID: <4DE0BB71.9000303@gmail.com>
Date: Sat, 28 May 2011 11:08:01 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>,
        tytso@mit.edu
Subject: Re: [PATCH 2/4] EXT4: Set NOSEC flag early when there are no xattrs
References: <1306536845-24162-1-git-send-email-andi@firstfloor.org> <1306536845-24162-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1306536845-24162-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/05/2011 00:54, Andi Kleen ha scritto:
> From: Andi Kleen<ak@linux.intel.com>
>
> This avoids a xattr lookup on every write.
>
> Cc: tytso@mit.edu
> Signed-off-by: Andi Kleen<ak@linux.intel.com>

Are ext2/3 affected too? It seems to me that more or less the xattr 
management for the extN series is the same, isn't it?

Marco
