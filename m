Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2DNAw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:52:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47015 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2DNAwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:52:25 -0400
Date: Fri, 13 Apr 2012 19:52:19 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>,
        Michel =?utf-8?Q?D=C3=A4nzer?= <michel.daenzer@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] drm/nouveau: Add lock on drm_helper_resume_force_mode
Message-ID: <20120414005219.GG13995@burratino>
References: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Peter Huewe wrote:

> mode_config should be locked when calling drm_helper_resume_force_mode.
> This patch adds the lock, similar to #927a2f119.

Does this fix a problem that has been observed in the wild, or only a
theoretical one?

Curious,
Jonathan
