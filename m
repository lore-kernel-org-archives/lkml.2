Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab0CPSaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:30:52 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:65028 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab0CPSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=mL66FU6SGeDbaTYb6gUrZw1dzm/p6CZK0+bLCTpWbd/wVWsofv4d2bQ/xj7sRYNniV
         aLnTL/0RRBvXD06KeKQWel0rF0BigXUPAV6h4d64P71Z5t/8hQfNByN50NW5xUSP6cBH
         zyUBjIX7APE7SkjRAOhvX6f3jyZCr6sq9cvZc=
MIME-Version: 1.0
In-Reply-To: <1cf6d37d1003161125n1b127d1av1bbce0b84ee00315@mail.gmail.com>
References: <1cf6d37d1003161125n1b127d1av1bbce0b84ee00315@mail.gmail.com>
Date: Tue, 16 Mar 2010 19:30:49 +0100
Message-ID: <1cf6d37d1003161130r2a69b2ebnd159b7d9bf10edb2@mail.gmail.com>
Subject: no kernel events
From: kees schoenmakers <kslinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm puzzled by a machine where "udevadm monitor --kernel" reports
nothing when items are connected/disconnected to USB. Only when I
disconnect the USB-keyboard I get one disconnect event and nothing
after. Reconnecting the keyboard leaves it unrecognised and
dis-functional.

Kees
