Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1CUSSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:18:55 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57329 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab1CUSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:18:52 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 19:22:10 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Migrations to hid-multitouch, round 3
Message-ID: <20110321182210.GA5181@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <alpine.LNX.2.00.1103211707520.19969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103211707520.19969@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1jgM-0002QB-78.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Q1jgM-0002QB-78 4844623c33bf1373cf36f74c5606d048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 21, 2011 at 05:09:14PM +0100, Jiri Kosina wrote:
> On Fri, 18 Mar 2011, Benjamin Tissoires wrote:
> 
> > This is the third version for this patch series.
> > 
> > Since last time, I mainly modified the patch #1 to adapt
> > Henrik's comments. I also added #4 as the code path was confusing.
> 
> Thanks a lot to everyone for working on this.
> 
> I have applied all the patches except for 5/5, where Henrik has reported 
> problems with testing against 1968 model. The problem hasn't been 

s/1968/2256/

> understood/debugged yet.

The reason is that the 2256 model sends extra data in each packet,
data that is not intercepted by the mt_event() function. The
last_field_index is therefore never seen, and no data is emitted. I
will reply to the original patch with a fix.

Thanks,
Henrik
