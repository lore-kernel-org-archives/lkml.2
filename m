Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1DJPJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:09:51 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:34375 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab1DJPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:09:45 -0400
Date: Sun, 10 Apr 2011 16:09:44 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Marc Koschewski <marc@osknowledge.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nice values zeroed after hibernate/suspend?
Message-ID: <20110410150943.GA11073@sucs.org>
References: <20110409223043.GA23372@marc.osknowledge.org> <20110409223228.GB23372@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409223228.GB23372@marc.osknowledge.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 12:32:28AM +0200, Marc Koschewski wrote:
> > 
> > I could report a false positive here when I'm dumb but ... it seems
> > like the nice values given to a process (-20) are zeroed (=0) when I
> > resume. Could anyone
> > please re-test this?

A suspend to ram/resume still shows a correctly set nice value on
my 2.6.39-rc2-00120-g94c8a98:

# nice -n -20 sleep 200 &
[1] 2460
# ps -eo "%c %n"  | grep [s]leep
sleep           -20
pm-suspend
<resume>
# ps -eo "%c %n"  | grep [s]leep
sleep           -20

-- 
Sitsofe | http://sucs.org/~sits/
