Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1BHX51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:57:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab1BHX50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:57:26 -0500
Date: Tue, 8 Feb 2011 15:55:45 -0800
From: Greg KH <gregkh@suse.de>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] staging: msm: Use explicit GPLv2 licenses
Message-ID: <20110208235545.GA2124@suse.de>
References: <1297208593-16368-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297208593-16368-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 03:43:12PM -0800, David Brown wrote:
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.

This paragraph is not needed at all.  Are you willing to keep track of
the FSF's address changes?  I'm sure not, and it's not relevant for this
file.

Care to redo this for all of these files?

thanks,

greg k-h
