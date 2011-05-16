Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1EPTKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:10:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56798 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab1EPTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <F41F2AE1-C4B5-4033-9225-7F2B83CBCCA1@slimlogic.co.uk>
References: <F41F2AE1-C4B5-4033-9225-7F2B83CBCCA1@slimlogic.co.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 May 2011 13:09:51 -0600
X-Google-Sender-Auth: 2953mh66hluaFkwLaD80uCpOrnU
Message-ID: <BANLkTim8C8qJND=TX2B4Eio1xT0TJ+6qEQ@mail.gmail.com>
Subject: Re: [PATCHv3 4/5] TPS65911: Add support for added GPIO line
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:50 PM, Jorge Eduardo Candelaria
<jedu@slimlogic.co.uk> wrote:
> GPIO 1 to 8 are added for TPS65911 chip version. The gpio driver
> now handles more than one gpio lines. Subsequent versions of the
> chip family can add new GPIO lines with minimal driver changes.
>
> The GPIO driver should reside in drivers/gpio/ for better
> organization.
>
> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>

This should be split into 2 patches.  One patch to move the file into
the new location plus any fixups needed to get it to compile from
there, and a second patch to make the function changes.  There is no
easy way to review what has functionally changed when move and rework
are in the same patch.

g.
