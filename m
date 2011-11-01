Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1KAWIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 18:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab1KAWIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 18:08:50 -0400
Date: Tue, 1 Nov 2011 18:08:45 -0400
From: Dave Jones <davej@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1+ iwlwifi lockup
Message-ID: <20111101220845.GA16080@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20111031143408.GA17152@redhat.com>
 <1320179254.31823.130.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320179254.31823.130.camel@wwguy-huron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 01:27:34PM -0700, Guy, Wey-Yi wrote:
 > Dave,
 > 
 > On Mon, 2011-10-31 at 07:34 -0700, Dave Jones wrote:
 > > I just got this trace, and a driver lockup that caused me to have to
 > > unload & reload the iwlwifi module to get networking back.
 > > hardware is..
 > > 04:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
 > > 
 > > This is new as of 3.1+  (This kernel was Linus' tree as of last night)
 > > 
 > >         
 > 
 > Any more information to help us understand how to re-produce the issue?
 > without more data, it is really hard to root cause and fix it.
 > 
 > Thanks
 > Wey

Wasn't doing anything special.  ssh, firefox, git clones.

	Dave

