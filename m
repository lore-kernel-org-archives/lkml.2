Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0DENoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:44:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60083 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0DENoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:44:04 -0400
Date: Mon, 5 Apr 2010 14:43:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Carl <carlchatfield@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Touchpad hacking, who to talk to before commencing work
Message-ID: <20100405134359.GA6263@srcf.ucam.org>
References: <x2pd56eedfb1004042305m3fdc4a8y7464a14e25cdb01c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x2pd56eedfb1004042305m3fdc4a8y7464a14e25cdb01c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 04:05:43PM +1000, Carl wrote:

> I have a new mbp 5, and I've been frustrated at the basicness of its
> operation compared to its functionality under osx. My original plan
> was to simply open
> up the bcm5974 and create a deadzone at the bottom of the touch pad so
> I could rest my thumb there and click. Configuration through synaptics
> doesnt seem to work for some reason.

Post-processing the output is probably better done in the synaptics 
driver at the X level.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
