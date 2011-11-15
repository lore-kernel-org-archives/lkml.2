Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1KOCjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:39:06 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56226 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab1KOCjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:39:04 -0500
X-Sasl-enc: MS5NNc+REX4t/79+nNhm6YT2sgtIZlIMIzgQluFQ6V4t 1321324743
Date: Tue, 15 Nov 2011 00:39:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Natanji <natanji@gmail.com>
Cc: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
Message-ID: <20111115023900.GA18799@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
 <20111114203021.GC31918@khazad-dum.debian.net>
 <4EC18D9E.5070108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC18D9E.5070108@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011, Natanji wrote:
> I also noticed that removing or replacing the tablet pen in its slot
> still yields an ibm/hotkey acpi event. This is the output of $
> acpi_listen when I do this:
> ibm/hotkey IBM0068:00 00000080 0000500c
> processor LNXCPU:00 00000081 00000000
> processor LNXCPU:01 00000081 00000000
> ibm/hotkey IBM0068:00 00000080 0000500b
> processor LNXCPU:00 00000081 00000000
> processor LNXCPU:01 00000081 00000000

Are those events above *exactly* the same on the kernel that is not
causing problems?

> So I suppose it is loaded alright, but just some of the events don't
> work anymore at all (like for my physical rfkill switch) and/or get
> overridden by other "standard" events (like with the sleep button).

Please give me the output of:
grep . /sys/bus/platform/devices/thinkpad*/*

(adjust that path if required, it may be slightly incorrect).  I really
want to know the contents of the hotkey_* sysfs nodes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
