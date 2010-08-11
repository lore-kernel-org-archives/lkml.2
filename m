Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0HKFoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 01:44:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47194 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0HKFob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 01:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IGzc+3MZ87wBr1ulnw1DkKRuKokjI3+ig+eaODlPKC1Ov6Yp25xWeG2w2Oj0RmHCR5
         Y8/ijCaVYaSCgkg53V8pOfiRBKlgA/Ti1OAVhjqJwBn3qGapTQkVCaanavpnZRW5X7hi
         7zqLbRchAuJ9fE8r+a1VlPqsJxxH65gueatMs=
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1281437191.1670.33.camel@leonhard>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
	 <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard>
	 <20100809064441.GC29524@basil.fritz.box> <1281337485.976.24.camel@leonhard>
	 <20100809072226.GD29524@basil.fritz.box> <4C604F54.2080506@zytor.com>
	 <20100810070555.GA16638@elte.hu>  <1281437191.1670.33.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 14:44:26 +0900
Message-ID: <1281505466.1677.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-10 (화), 19:46 +0900, Namhyung Kim:

> No problem. :-) But before that, let me clarify this: It seems
> -fno-strict-overflow is all about the signed arithmetic and
> __pa_symbol() does unsigned one. Is it really matters here?
> 
> 

Oops, my bad, I found the description of -fstrict-overflow in gcc manual
that it also affects the semantics of pointer and unsigned integer
arithmetic. Sorry for the noise.

-- 
Regards,
Namhyung Kim


