Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1HaVaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:30:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38062 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756110Ab1HaV36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:29:58 -0400
Date: Wed, 31 Aug 2011 22:28:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/4] TTY: serial, fix build of some drivers
Message-ID: <20110831222850.494bf19d@lxorguk.ukuu.org.uk>
In-Reply-To: <1314818699-10873-3-git-send-email-jslaby@suse.cz>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
	<1314818699-10873-3-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 21:24:58 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> I'm getting build errors such as:
> .../tty/serial/max3107.c: In function ‘put_data_to_circ_buf’:
> .../tty/serial/max3107.c:149:2: error: implicit declaration of function ‘tty_insert_flip_string’
> 
> Those drivers need to include linux/tty_flip.h. The question is
> whether we want to fix them at all. As they are broken for some time
> already and nobody noticed...

Config options randomly including it ?
