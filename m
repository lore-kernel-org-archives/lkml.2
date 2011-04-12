Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab1DLSKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:10:41 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:34409 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758260Ab1DLSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:10:40 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1MYMDFMVM1lCaja5W5l_ZOuG2l1uvVnT20fUEMgrmh.4QiV
 klv_vjI3hPa.6StH5VWAMxwK95l_rfjZtqAiRFS5MdaFwnPNKcb4PMyub.F3
 nIM_0oCQq5KtLqdv4j.6ii3KQWIQnTAUQgWBUWairW.d4xzaLE9BY8UNeMfS
 R0To7eebrch_EX6Z19OCWmM99Sg2W5EFdxl72ufY4lzvDKnJyKDZj8ZoTiGD
 c8yeASefTFFFWkQe736Y2DTAprCujZiJbup0wsqUAOY7leU3CUjN18gEVMM4
 mbmzo3g9qlSbYt7TZ9gNudKqf2dcoIU.Nixi5WZ8huv0bLO01VESC
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Apr 2011 13:10:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Weinberger <richard@nod.at>
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        penberg@kernel.org, hpa@zytor.com
Subject: Re: um: this_cpu_cmpxchg16b_emu
In-Reply-To: <201104121609.56901.richard@nod.at>
Message-ID: <alpine.DEB.2.00.1104121309480.14692@router.home>
References: <201104121609.56901.richard@nod.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Richard Weinberger wrote:

> This patch implements this_cpu_cmpxchg16b_emu() for UML.

Is this really necessary? Just undefine CONFIG_CMPXCHG_LOCAL for UML and
the asm code will not be used.

