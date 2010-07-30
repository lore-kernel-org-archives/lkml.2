Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0G3Mon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:44:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0G3Mol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jOaS6VdTX1oFHs4AHnSssbPyq7QxhYurNJtco5EtOw8kLT9Fdiu6tJnq7ZqdJv/xKA
         zRqEd4FMHknQ7bKOHPdHkCvoKyJHLWESR+D68/Edod/nlL+CTgWT7raowZ9EuaW61K6/
         SGC3VJa11bQJO4MMBxXiXsf5KATiZhzUn50RQ=
Message-ID: <4C52C935.5020900@gmail.com>
Date: Fri, 30 Jul 2010 14:44:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 1/9] staging: dt3155: check put_user() return value
References: <1280488030-20697-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280488030-20697-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 01:07 PM, Kulikov Vasiliy wrote:
> put_user() may fail, if so return -EFAULT.
> Also compare count with copied data size, not size of struct with these
> fields.

Please do whitespace cleanup separately. We cannot review this.

-- 
js
