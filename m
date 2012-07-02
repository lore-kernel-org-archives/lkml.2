Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2GBHgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:36:24 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:54423 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2GBHgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:36:22 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au5PAGBO8U9V5qg+PGdsb2JhbABFihWsRRkBAQEBHhkNJ4IYAQEFOhwjEAgDDgouFCUKGhOGEYF+uzEUiyeFOmADlTOFZox/gV0
X-IronPort-AV: E=Sophos;i="4.77,508,1336341600"; 
   d="scan'208";a="73155256"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 2 Jul 2012 09:36:33 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: synaptics - add sysfs access to firmware ID &
 board ID
Message-ID: <20120702073632.GB624@polaris.bitmath.org>
References: <1340859117-19654-1-git-send-email-djkurtz@chromium.org>
 <1340859117-19654-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340859117-19654-2-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 12:51:57PM +0800, Daniel Kurtz wrote:
> Allow userspace to query firmware ID and board ID, which are read and
> cached during device initialization.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |   41 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)

Since there is no common way to extract the firmware id for input
devices, any userland code that wants to use these sysfs nodes needs
to know about the details of this specific driver. I am not sure the
usefulness of it all outweighs the complication it incurs. It would be
good to hear about the rationale for inclusion here.

Thanks,
Henrik
