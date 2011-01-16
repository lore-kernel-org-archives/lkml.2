Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1APC6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 21:58:41 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:45742 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1APC6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 21:58:39 -0500
From: Ingo Brunberg <ingo_brunberg@web.de>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: BUG in rt2x00lib_txdone() with 2.6.37-rc8
In-Reply-To: <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com> (message from Ivo Van Doorn on Sat, 15 Jan 2011 14:34:11 +0100)
References: <m31v4hkmkf.fsf@ingo.homenetwork>
	<201101131423.51640.helmut.schaa@googlemail.com> <AANLkTimMVdsGONSD9OmnX2eJk51H5Pzj4K8irHa=E-qx@mail.gmail.com>
Date: Sun, 16 Jan 2011 03:58:06 +0100
Message-ID: <m3pqrxr1vl.fsf@ingo.homenetwork>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V01U2FsdGVkX1/vSpkTLFS/MmeNkRF1smV3EJDIXsVFRqqwiOWN
	kNjwAjVkNVjmJ8ziC1gq8L6DGEtAED17n39gOdreLxZ8yY5M5T
	zSFNSlFhUSFG58uXsrGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo Van Doorn <ivdoorn@gmail.com> writes:

> This could be, would be interesting to know if compat-wireless also shows
> this problem. Because the queue refactoring code which should have solved
> these race conditions was added after 2.6.37.

I really would like to give it a try, but compat-wireless-2011-01-15
crashes right on module loading. Is there a version known to work?
