Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0D1LvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:51:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:55409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab0D1LvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:51:23 -0400
Date: Wed, 28 Apr 2010 13:51:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Wayne Thomas <waynethomas69@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HID: expand hid-topseed driver to support BTC "Emprex 3009URF
 III  Vista MCE Remote"
In-Reply-To: <y2u3711715e1004272206u4700fac7u744b2fb0cf203367@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1004281349130.9849@pobox.suse.cz>
References: <t2g3711715e1004240718m8aacffc5o68fc9ccd1e66f212@mail.gmail.com>  <w2l3711715e1004271145v133cd94ax971aa213eb60cfaa@mail.gmail.com>  <alpine.LNX.2.00.1004272242050.9849@pobox.suse.cz>
 <y2u3711715e1004272206u4700fac7u744b2fb0cf203367@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Wayne Thomas wrote:

> >> OK, next attempt...
> >
> > The patch is OK, but your mail client whitespace-damaged it. Could you
> > please fix up your client and resend? (or attach it separately as an
> > attachment, if your client can't be fixed).
> >
> > Thanks,
> 
> I thought it might have; sorry about that.
> Have attached patch as separate file as a precaution.

Thanks for the patch.

What is the reason for it being backwards-compatible with the older 
topspeed device?

Changes such as

-	case 0x048: ts_map_key_clear(KEY_RED);            break;
+	case 0x05b: ts_map_key_clear(KEY_RED);          break;

(and no other handling of neither 0x048 nor KEY_RED) make me wonder ...

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
