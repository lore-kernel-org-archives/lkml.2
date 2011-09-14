Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1INLIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 07:08:17 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:40521 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab1INLIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 07:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E6FFE3E.1090702@gmail.com>
References: <4E6FFE3E.1090702@gmail.com>
Date: Wed, 14 Sep 2011 07:02:35 -0400
Message-ID: <CA+5PVA4WQ3M2NM_BskL4==UwJ_XthVpynmQUHO+1R3-4-XdBRQ@mail.gmail.com>
Subject: Re: 3.0.3 nouveau: page allocation failure and oops
From: Josh Boyer <jwboyer@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 9:07 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Just saw this page allocation failure followed by a null pointer dereference
> in Fedora 15 2.6.40.3-0 (aka 3.0.3). This is with a GeForce 9600GT. Is this
> already known?

There are a handful of nouveau patches in the newer F15 kernel.  Your
issue looks fairly similar to RH bugzilla 699551.  You should try the
latest stable kernel update (2.6.40.4-5).

josh
