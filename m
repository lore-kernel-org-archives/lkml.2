Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0HaGKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:10:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0HaGKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jpGOS7aHDnjotqyd/RrUQquvBBqiynKEG0xc3u+0zMB6ZducSFFaWKIxqULLaO0T18
         e0O/g3lZz5XNp2jj/iefy4OqZbSHJga2sxryMwLbV9az0nmF2F9MnVEZgD1I48zIudO2
         ZGC+cdzx1V72IlsKIwL5CDqdLnoNI48Ex28xo=
Message-ID: <4C7C9C79.5050504@suse.cz>
Date: Tue, 31 Aug 2010 08:08:57 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>	<20100830184737.GA21339@suse.de>	<201008302333.22447.arnd@arndb.de> <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 12:28 AM, Alan Cox wrote:
>> riscom,isicom           -> drivers/staging/tty/*
> 
> isicom has users and gets tested a bit

Are you sure about isicom:
https://bugzilla.kernel.org/show_bug.cgi?id=11067
? The last kernel he tried was 2.6.28 and there isicom sleeps forever in
isicom_open.

thanks,
-- 
js
suse labs
