Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1BHR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:29:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182Ab1BHR3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:29:20 -0500
Date: Tue, 8 Feb 2011 12:29:11 -0500
From: Dave Jones <davej@redhat.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110208172910.GA32742@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Ira W. Snyder" <iws@ovro.caltech.edu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1297121021-3522-1-git-send-email-iws@ovro.caltech.edu>
 <1297121021-3522-2-git-send-email-iws@ovro.caltech.edu>
 <20110208073309.GB906@core.coreip.homeip.net>
 <20110208172046.GB10125@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208172046.GB10125@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:20:46AM -0800, Ira W. Snyder wrote:

 > > > +static DEVICE_ATTR(enable, S_IWUGO | S_IRUGO, data_en_show, data_en_set);
 > > 
 > > Are all of these really needed or most of them are for debug?
 > > 
 > 
 > Most are for debugging. They have proved useful a few times in
 > production to track down bugs.
 
File mode should probably not be world writable.
(checkpatch.pl should warn you about this now btw)

	Dave

