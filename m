Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1KMOU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 09:20:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53799 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab1KMOU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 09:20:56 -0500
MIME-Version: 1.0
In-Reply-To: <CADDKRnCq_h5YPcSCoOnW3q+8Q8r5UV3Wj6oJ4UE5UV+Keb1M1Q@mail.gmail.com>
References: <CADDKRnCq_h5YPcSCoOnW3q+8Q8r5UV3Wj6oJ4UE5UV+Keb1M1Q@mail.gmail.com>
Date: Sun, 13 Nov 2011 15:20:55 +0100
Message-ID: <CADDKRnD6oL-WAdDowLoC9e8nqNdg9_coCaS49rfTY2PxCCwZvw@mail.gmail.com>
Subject: [v32-rc1+] radeon kernel crash
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit causes the kernel to crash:
commit 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc
 "drm/radeon/kms/pm: switch to dynamically allocating clock mode array"

It happens at a very early stage. So I have no logs, no displays, no
nothing.
Reverting 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc fixes the problem.
HW is a Thinkpad T43.
