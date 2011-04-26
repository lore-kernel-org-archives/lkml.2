Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1DZKqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:46:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60122 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753957Ab1DZKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:46:39 -0400
Date: Tue, 26 Apr 2011 11:46:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] davinci-mcasp: correct tdm_slots limit
Message-ID: <20110426104635.GA13252@opensource.wolfsonmicro.com>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
 <e6aa9fd05c44088ab8446f1c60d2056f92929483.1303408522.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6aa9fd05c44088ab8446f1c60d2056f92929483.1303408522.git.bengardiner@nanometrics.ca>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 02:19:01PM -0400, Ben Gardiner wrote:
> The current check for the number of tdm-slots specified by platform data is
> always true (x >= 2 || x <= 32); therefore the else branch that warns of an
> incorrect number of slots can never be taken.

Applied all of these.  Please always try to ensure that your commit logs
are consistent with the rest of the subsystem so they don't need to be
rewritten.
