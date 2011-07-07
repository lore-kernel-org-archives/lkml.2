Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1GGSyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:54:47 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:29452 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752466Ab1GGSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:54:44 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Lzna1k8VM1nS2jagTDE9fLo_NmTOAOfGpwLCxvvKFaI4Lu8
 7XU7rzCW3nd7K.jeLFtL6sxXzakvZBo9v0FfKFj5aHV_TR2ismtVHeIF_WIj
 GrK78YD80hGxB1C49OxwhCWqr7EaUIRFtwEdzhL.mHXWrWr5ohxPYP1XyEaK
 kLp60qSpZxrmAX_FnUnfaMXu4ZudVhd2G0xKfLPlPrhc8PUONpGz5UVt554F
 8exWfAZf2NvgwjieGZxC1J6IANJ3v9plNnJSa3Eh2lYKbPAEBCK3lVeS4KoN
 jqXt5321OXbweJ2SIeqiI1rGPcwMZO_ZUrR8CzHKqZGmkja4-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 13:54:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ben Greear <greearb@candelatech.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] slub: Enable backtrace for create/delete
 points.
In-Reply-To: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1107071352120.21719@router.home>
References: <1310063797-14914-1-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, greearb@candelatech.com wrote:

> +#define TRACK_ADDRS_COUNT 16

16 may be a bit high. In the past we used 4 or 6 in the implementation
for slab.

Acked-by: Christoph Lameter <cl@linux.com>

