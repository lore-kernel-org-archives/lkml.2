Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1IWIoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:44:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50585 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1IWIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:44:16 -0400
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 10:44:15 +0200
Message-ID: <CADDKRnA+i3Tq5AF80fpnL7PFj-73+_R1N+9W7=a+iBwjMNqwWQ@mail.gmail.com>
Subject: [v3.1-rc7]: Radeon regression
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v3.1-rc7 I'm seeing only garbage on the desktop.

The following reverts help:
d8751cdb4cb7e4017c83d1832b4eb720b017e9aa revert "drm/radeon/kms: fix
typo in r100_blit_copy"
2e84ca5b63b2224447a99d29ba8e6419a6a9e506 revert "drm/radeon/kms: Make
GPU/CPU page size handling consistent in blit code (v2)"

This is a Thinkpad T43 with:
01:00.0 VGA compatible controller: ATI Technologies Inc M22 [Mobility
Radeon X300]
