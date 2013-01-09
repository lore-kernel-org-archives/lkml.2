Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3AIOSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:18:55 -0500
Received: from fieldses.org ([174.143.236.118]:56797 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766Ab3AIOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:18:54 -0500
Date: Wed, 9 Jan 2013 09:18:53 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
Message-ID: <20130109141853.GB32710@fieldses.org>
References: <20130103204624.GA2533@fieldses.org>
 <CA+5PVA6PSsWGVAvSkdZXgoPaaroTuC0LvJ6-3mo1aU9LEUA1Sw@mail.gmail.com>
 <20130103231123.GD3238@fieldses.org>
 <20130106180652.GQ5737@phenom.ffwll.local>
 <20130108143710.GA16343@fieldses.org>
 <CAKMK7uG-1xoc49HhCxrpgO2xgsskJ6YXo7GBHCwsgQrSuDXd4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uG-1xoc49HhCxrpgO2xgsskJ6YXo7GBHCwsgQrSuDXd4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:27:22PM +0100, Daniel Vetter wrote:
> On Tue, Jan 8, 2013 at 3:37 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >> please grab the i915_error_state file from debugfs
> >
> > As I said in the original mail, I've already done that:
> >
> >         http://fieldses.org/~bfields/3.8-hang/
> 
> Sorry, missed that the first time around.
> 
> >> and file a bug on
> >> bugs.freedesktop.org against DRM - DRI (Intel).
> >
> > Would it still be useful for me to file a bug?  (Just going through the
> > new-account confirmation dance now.)
> 
> Looks like the ilk bug tracked at
> https://bugs.freedesktop.org/show_bug.cgi?id=55984

OK, I'll add something there if I'm available to find a reproducer.
Thanks!

--b.
