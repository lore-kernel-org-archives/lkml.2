Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0GIV0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:26:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0GIV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JN4VP27LQLOfWnBi+3BZp3+sN/XW6Hfl476GGGFULzZFih+VoHBG37iHpo3+XNxrqh
         ebz0Ycw9QhyzSjupata25bJ3AS0WzpXtS3RDSInq7HLd/5T50OVC8XfwTItA4AUe7X6c
         0/HkyO2jN0nA4oM+TePChiWYHx6DWWEWjoulY=
Message-ID: <4C3793FB.4080907@gmail.com>
Date: Fri, 09 Jul 2010 23:26:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>, Christopher Li <sparse@chrisli.org>,
       Linux-Sparse <linux-sparse@vger.kernel.org>
Subject: Re: Warning message when using sparse
References: <4C3680D1.5070601@lwfinger.net> <4C378AD9.1070602@gmail.com> <4C379323.1090004@lwfinger.net>
In-Reply-To: <4C379323.1090004@lwfinger.net>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 11:22 PM, Larry Finger wrote:
> Obviously, I pulled the wrong git tree. I got the one from the wiki.
> When I built the one from the kernel.org tree, all is well.

Both are from kernel.org. But the one I sent is a Chris'es "fork" with
my and other fixes.

-- 
js
