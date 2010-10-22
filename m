Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0JVM7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:59:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53823 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754545Ab0JVM7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:59:02 -0400
Date: Fri, 22 Oct 2010 13:58:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pghatwork@gmail.com
Cc: par-gunnar.p.hjalmdahl@stericsson.com, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] mfd: Add support for the ST-Ericsson CG2900 Audio.
Message-ID: <20101022135804.6f55be40@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTinHV3qyMRsjAn92uZZp22whESpJDZUfCHcy=Eh9@mail.gmail.com>
References: <AANLkTinHV3qyMRsjAn92uZZp22whESpJDZUfCHcy=Eh9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 12:39:06 +0200
Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com> wrote:

> This patch adds support for controlling audio paths within
> the ST-Ericsson CG2900 Connectivity Combo controller.
> This patch adds API for the Kernel as well as a char device for
> user space stacks to control the CG2900 audio paths.

I don't see any ALSA hooks for audio or any V4L hooks for the FM radio.
Surely the audio routing wants exposing as a mixer and the audio via
ALSA, likewise FM radio is video4linux so that it'll have the standard
interfaces that are expected by the rest of the Linux OS.

Alan
