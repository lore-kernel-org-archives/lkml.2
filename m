Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2A0KOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:14:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64875 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2A0KOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:14:15 -0500
Date: Fri, 27 Jan 2012 11:14:03 +0100
From: Lubos Kolouch <lubos.kolouch@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Message-ID: <20120127101403.GA2213@nbgentoo.nlcz.cz>
References: <jfe47e$5dn$1@dough.gmane.org>
 <86mx9gkjlv.fsf@sumi.keithp.com>
 <20120121184453.GA2698@nbgentoo>
 <86hazokcb7.fsf@sumi.keithp.com>
 <20120122102912.GA2123@nbgentoo>
 <867h0j83vx.fsf@sumi.keithp.com>
 <20120123063313.GA2113@nbgentoo>
 <86vcnyc3t3.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86vcnyc3t3.fsf@sumi.keithp.com>
X-Operating-System: Linux nbgentoo 3.3.0-rc1-00001-g2d0c0a1
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012, 23:37:28, Keith Packard wrote:
> On Mon, 23 Jan 2012 07:33:14 +0100, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> 
> > dmesg after boot - http://paste.pocoo.org/show/539115/
> > dmesg after OK resume - http://paste.pocoo.org/show/539117/
> 
> I've posted a couple of more comprehensive patches that you should have
> received; I'd like to know if you can test them to see if they resolve
> the issue as well.

1) applied the first patch, resume works OK
dmesg after boot : http://paste.pocoo.org/show/541205/
dmesg after resume : http://paste.pocoo.org/show/541206/

2) applied second patch on top, resume works OK
dmesg after boot: http://paste.pocoo.org/show/541477/
dmesg after resume : http://paste.pocoo.org/show/541479/

Lubos

