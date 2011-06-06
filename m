Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1FFQaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:30:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1FFQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AfnEs967fNSU52kYxnk9iQEtiIgNwOwuoJQIeiBA5lFE21DXU3LzXMcMeq/SvW/HnB
         2w14Qe+/poQnt5pUT/CF5PVcY90RMxcuOJOcN2Pplxx1f6zOnp84cJEGQPvZwuutceVJ
         9Ae8V5or6z7JOHTBCYpPnRtKNY2lmgAkbrnfg=
MIME-Version: 1.0
In-Reply-To: <20110606070553.9829.40823.stgit@ponder>
References: <20110606070553.9829.40823.stgit@ponder>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jun 2011 12:29:49 -0400
Message-ID: <BANLkTiko2A3bthjVL_NR0yaQP_8Nq5VmqQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: reorganize drivers
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 03:06, Grant Likely wrote:
> Sort the gpio makefile and enforce the naming convention gpio-*.c for
> gpio drivers.

ml_ioh_gpio.c and pch_gpio.c use KBUILD_MODNAME with
pci_request_regions, but i think that func only uses it for /proc/
status info, so maybe it's ok ?
-mike
