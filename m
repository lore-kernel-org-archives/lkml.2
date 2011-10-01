Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1JAR6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:58:41 -0400
Received: from caprica.metux.de ([82.165.128.25]:36409 "EHLO
	mailgate.caprica.metux.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018Ab1JAR6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:58:16 -0400
Date: Sat, 1 Oct 2011 19:30:02 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20111001173002.GB15179@nibiru.local>
Reply-To: weigelt@metux.de
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1316088425.11294.78.camel@lappyti> <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari> <yun8vpp7qk7.fsf@aiko.keithp.com> <4E72320B.6020000@gmx.de> <yunwrd965fp.fsf@aiko.keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunwrd965fp.fsf@aiko.keithp.com>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keith Packard <keithp@keithp.com> wrote:

> Jesse's design for the DRM overlay code will expose the pixel formats as
> FOURCC codes so that DRM and v4l2 can interoperate -- we've got a lot of
> hardware that has both video decode and 3D acceleration, so those are
> going to get integrated somehow. And, we have to figure out how to share
> buffers between these APIs to avoid copying data with the CPU.

Really naive question: where are these buffers laying ?
I guess, somewhere in the device, not in main memory (otherwise,
it wouldn't be a problem, right ?). So, the question to answer is:
how (of the subdevices) can see whose buffers and how to map
their local addresses.

Am I correct ?


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 phone:  +49 36207 519931  email: weigelt@metux.de
 mobile: +49 151 27565287  icq:   210169427         skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------
