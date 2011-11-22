Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1KVWyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1KVWyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:54:14 -0500
Date: Tue, 22 Nov 2011 17:54:09 -0500
From: Dave Jones <davej@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.1+ iwlwifi lockup
Message-ID: <20111122225409.GA23889@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20111031143408.GA17152@redhat.com>
 <1321992902.8072.7.camel@wwguy-ubuntu>
 <20111122204741.GA3764@redhat.com>
 <1321991916.11647.77.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321991916.11647.77.camel@wwguy-huron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:58:36AM -0800, Guy, Wey-Yi wrote:
 > Hi Dave,
 > 
 > Not sure what happens, feel like memory corruption but not sure. the
 > contain of the command is totally bogus.
 > 
 > Could you please test and send update, it is part of "3.2+rc2+
 > Regressions from 3.0 and 3.1" reports
 
Will do.

Not sure if it's a helpful data point, but the access point is
an apple airport (in case that's sending something strange that
confused the firmware).

	Dave
 
