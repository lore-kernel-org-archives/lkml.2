Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1ALQ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:56:46 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36623 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:56:43 -0500
Date: Wed, 12 Jan 2011 17:56:37 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: "Ted Ts'o" <tytso@mit.edu>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Oops while going into hibernate
In-Reply-To: <20110112162655.GA13496@thunk.org>
Message-ID: <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Jan 2011, Ted Ts'o wrote:
> On Wed, Jan 12, 2011 at 02:48:58PM +0100, Sebastian Ott wrote:
> > Hi,
> > 
> > while goning into hibernation right after resuming with
> > 2.6.37-05668-g4162cf6 on S390 I get this one:
> 
> Hmm... what are you hibernating to?  A swap device?  A file-backed
> swap device?
swap device.

Regards,
Sebastian
