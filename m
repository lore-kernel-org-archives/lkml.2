Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0HXEo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:44:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38591 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0HXEoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Oi2A9ZqFFUjFRHKh+Tqo/TERmxnjc8Y3hr23b1Q0C6qi0QI5OSyh+4pKwgY6f13sV/
         NJ+cX8837OsSPg47FIS8VXpDVgGy+b0u1fcyzZDwImpu/zgKwGieoNO0tydZdesFVyf2
         GuhQaLsP1VpauIoRcxwy/X0zljc0L8lyCHK1E=
Subject: Re: help needed with EXPORT_SYMBOL
From: Aijaz Baig <aijazbaig1@gmail.com>
Reply-To: aijazbaig1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: peterz@infradead.org, brgerst@gmail.com, jengelh@medozas.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinRyoHcSmmHv9tZ36X4wxVVCKGLDwGiZUTPPn+z@mail.gmail.com>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	 <1282569477.2605.1798.camel@laptop>
	 <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
	 <1282572346.2605.1856.camel@laptop>
	 <AANLkTimQDV74kcM_84QySMKmdf-XxFOhqp48cQdQNN4s@mail.gmail.com>
	 <AANLkTinRyoHcSmmHv9tZ36X4wxVVCKGLDwGiZUTPPn+z@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 10:14:14 +0530
Message-ID: <1282625054.4080.152.camel@aijazbaig1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, 

thanks for sending in the replies with so many options. I am still a
relative newbie so please do bear with me guys if I sound a bit naive at
times.

I'll first start with brian's suggestion. He said:
"Use an exported function pointer in the main kernel as a hook that the
module sets when it is loaded.  Note, you must use module_get and
module_put around the call to the module to prevent it from unloading
while in use."

I have never used such a technique and do not understand what you mean.
Could you please elaborate a little. Do you mean I should NF_HOOK within
the kernel code and then make the function that I would like to execute
as the hookfn? Well..if this is what u meant then wouldn't it also cause
all hooks at that particular position to be executed as well? 

And then peter and finally jan came up with, perhaps better suggestions
(i really cannot judge the quality of any of these suggestions..m too
much of a noob to do that). I got confused in the XY explanation by jan
since there both X and Y are modules it seems and I was talking about a
module exporting a certain symbol to be used by the kernel. Peter did
suggest notification chains. Is there a simple example that I can look
at? Will it allow the kernel to see symbols defined within the module? 

Lastly, will I be able to use kallsyms_lookup() to do what I can? I
notice that it replaced EXPORT_SYMTAB sometime back. So if yes I can use
it, does anyone know how to fill in the very first parameter of this
function which says address (of what exactly and how am I supposed to
know this address?)

Keen to hear from you and once again, thank you for your inputs,

Regards,
Aijaz Baig.





