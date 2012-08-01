Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2HARhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:37:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61161 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2HARhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120801133835.GH5470@ics.muni.cz>
References: <20120801133835.GH5470@ics.muni.cz>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 1 Aug 2012 10:37:01 -0700
X-Google-Sender-Auth: ffnrfYS-tiKDiN2PDc8ptmwipXQ
Message-ID: <CAG4TOxONLJnBaY7N5x7Kfi+dwCb507QPqX9s_Wuef10+RzM=AQ@mail.gmail.com>
Subject: Re: mellanox mlx4_core and SR-IOV
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 6:38 AM, Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
> [    3.558296] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV (nres: 0, iov->nres: 1)

This comes from the core sriov_enable() function, not anything in mlx4.
(although my kernel doesn't have the print of nres in that message)

Not sure what it means.
