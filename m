Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0HIVXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:23:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0HIVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M4xHJDBBw6On9wbRW6F5H8ncl5u7E9ifNQlZaH02j9X42ePLmRvvJWMv/FFzEJGAgw
         8U8lErj6rInzXeIqaQdBFmNK+yw3WyFcetQE9PLRS1Wm1te4f5IklcKoFDLq2XqbbxiI
         i8erQww2rSaPDsG4B3rtRSRLbfdN+H2chSzsQ=
Message-ID: <4C6071DC.3010100@gmail.com>
Date: Mon, 09 Aug 2010 18:23:40 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100806 Lanikai/3.1.2
MIME-Version: 1.0
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
CC: Paul Rolland <rol@as2917.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <20100804083732.3d8dae69@tux.DEF.witbe.net> <4C59192F.3010304@infracom.it>
In-Reply-To: <4C59192F.3010304@infracom.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello Roland,
>     I did reply on the same thread confirming that that's the same 
> issue I was having and that the proposed workaround did work for me.
> After some days of testing I'm observing sporadic lockup on resume 
> (not in suspend as in my original report), but I think this is another 
> issue.
>

something like this? https://bugzilla.kernel.org/show_bug.cgi?id=16396

check my last post there
