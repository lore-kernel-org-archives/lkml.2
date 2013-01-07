Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3AGTXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:23:38 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63431 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3AGTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:23:37 -0500
Date: Mon, 7 Jan 2013 11:23:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 9/9] Thermal: Dummy driver used for testing
Message-ID: <20130107192333.GB4465@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-10-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357542806-20449-10-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:43:26PM +0530, Durgadoss R wrote:
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.

Unless you wish to track the office movements of the FSF for the next
40+ years, never include this in the code, it's useless.

thanks,

greg k-h
