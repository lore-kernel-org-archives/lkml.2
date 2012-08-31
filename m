Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2HaQE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:04:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57041 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab2HaQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:04:25 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 31 Aug 2012 09:04:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hwmon: add Maxim MAX197 support
Message-ID: <20120831160439.GA5756@roeck-us.net>
References: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:42:57PM -0400, Vivien Didelot wrote:
> The MAX197 is an A/D converter, made by Maxim. This driver currently
> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> 
> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied to -next.

Thanks,
Guenter
