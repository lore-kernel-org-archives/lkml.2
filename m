Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0GIVWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:22:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52973 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0GIVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dVb8Ov6Omq8EiVofQgo4ZAJgQDzvRsjvinWsYXI0tntbDDW4zdovHgj+LdJQ1ySY3F
         4nh2T7MUY8XQ/sCsjp6L5u+uCZbryIudQBM3EbTcand8QPIo1JrbS101QJin9jb/iQIq
         94MdkQyXwPdKszxMRv75NfSN6wtJQ6fRXVDOI=
Message-ID: <4C379323.1090004@lwfinger.net>
Date: Fri, 09 Jul 2010 16:22:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christopher Li <sparse@chrisli.org>,
       Linux-Sparse <linux-sparse@vger.kernel.org>
Subject: Re: Warning message when using sparse
References: <4C3680D1.5070601@lwfinger.net> <4C378AD9.1070602@gmail.com>
In-Reply-To: <4C378AD9.1070602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obviously, I pulled the wrong git tree. I got the one from the wiki. When 
I built the one from the kernel.org tree, all is well.

Larry

