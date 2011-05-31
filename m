Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1EaGaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:30:25 -0400
Received: from mail.perches.com ([173.55.12.10]:2343 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1EaGaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:30:24 -0400
Subject: RE: [PATCH 1/1] aat2870: Adding backlight, regulator and mfd driver
From: Joe Perches <joe@perches.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1306815974-29482-1-git-send-email-jinyoungp@nvidia.com>
References: <1306815974-29482-1-git-send-email-jinyoungp@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 23:30:22 -0700
Message-ID: <1306823422.20175.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 13:26 +0900, Jin Park wrote:
> Please review the driver.
> Adding backlight, regulator and mfd driver for AnalogicTech AAT2870.
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -0,0 +1,265 @@
> +/*
[]
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */X-NVConfidentiality: public

This stray "X-NVConfidentiality: public" should be removed.


