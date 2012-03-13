Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2CMNhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:37:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48501 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2CMNhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <1331569731-30973-1-git-send-email-alexg@meprolight.com>
References: <1331569731-30973-1-git-send-email-alexg@meprolight.com>
Date: Tue, 13 Mar 2012 10:37:30 -0300
Message-ID: <CAOMZO5Dmf3mqDZkrhnFLrFyc90vk8Vyfv5mwrFfWsY-05=AyJg@mail.gmail.com>
Subject: Re: [PATCH] i.MX35-PDK: Add Camera support
From: Fabio Estevam <festevam@gmail.com>
To: Alex <alexg@meprolight.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Mon, Mar 12, 2012 at 1:28 PM, Alex <alexg@meprolight.com> wrote:
> In i.MX35-PDK, OV2640  camera is populated on the
> personality board. This camera is registered as a subdevice via soc-camera interface.
>
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>

Are you able to get the camera working correctly now?

Or are you still facing the issues you reported earlier?
