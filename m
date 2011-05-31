Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1EaTRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:17:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58393 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154Ab1EaTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110531155140.3507.6599.sendpatchset@prarit.bos.redhat.com>
References: <20110531155140.3507.6599.sendpatchset@prarit.bos.redhat.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 May 2011 13:17:03 -0600
X-Google-Sender-Auth: yyZMk2bnX-MxLGUHyfvzc5scn1U
Message-ID: <BANLkTi=eRoTKNsBxp483kr1ZFh=MQKi2kQ@mail.gmail.com>
Subject: Re: [RFC PATCH 09/35] drivers/gpio changes for SMBIOS and System Firmware
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit

I could use some background on why the mod_devicetable.h include is
being removed from basic_mmio_gpio (need a commit description).  Also,
any reason why this change isn't squashed in the patch that
necessitates it?

g.

On Tue, May 31, 2011 at 9:51 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
