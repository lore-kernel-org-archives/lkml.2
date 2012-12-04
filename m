Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2LDHKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:10:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60222 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2LDHKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:10:40 -0500
MIME-Version: 1.0
In-Reply-To: <1354168359-19459-1-git-send-email-qingx@marvell.com>
References: <1354168359-19459-1-git-send-email-qingx@marvell.com>
Date: Tue, 4 Dec 2012 15:10:39 +0800
Message-ID: <CAN1soZyVCV6RWX4yq7BSuP2UcpBMYDuncfo9o5QDNW0o2W2rSQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: add docs for max8925 dt
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Qing Xu <qingx@marvell.com>
Cc: rob@landley.net, linux-doc@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, cxie4@marvell.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:52 PM, Qing Xu <qingx@marvell.com> wrote:
> From: Qing Xu <qingx@marvell.com>
>
> add docs for dt of max8925-mfd, max8925-backlight, and
> max8925-battery
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>  Documentation/devicetree/bindings/mfd/max8925.txt  |   64 ++++++++++++++++++++
>  .../bindings/power_supply/max8925_batter.txt       |   18 ++++++
>  .../bindings/video/backlight/max8925-backlight.txt |   10 +++
>  3 files changed, 92 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max8925.txt
>  create mode 100644 Documentation/devicetree/bindings/power_supply/max8925_batter.txt
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/max8925-backlight.txt
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
