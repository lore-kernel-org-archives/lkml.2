Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2GaWXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:23:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39829 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab2GaWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:23:44 -0400
Date: Tue, 31 Jul 2012 15:23:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120731222338.GA19134@kroah.com>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-2-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343607994-32415-2-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 05:26:33PM -0700, Jon Mason wrote:
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

You really are going to track the FSF's office movements for the next
40+ years?

> + *   The full GNU General Public License is included in this distribution
> + *   in the file called LICENSE.GPL.

No it isn't, this sentance is totally wrong for any in-kernel code,
please remove it.

Also do the same for all the other files you added please.

greg k-h
