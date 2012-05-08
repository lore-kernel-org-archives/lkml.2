Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2EHTc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:32:27 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:42790 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2EHTcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:32:25 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AntxAGt0qU9V5qg+PGdsb2JhbABEsg4DgRsZAQEBATc0ggwBAQEBAwECLwEjIxAIAxguFBQRChqIJQe7OROKcHCEP2MEk0+CLoYGjSg
X-IronPort-AV: E=Sophos;i="4.75,553,1330902000"; 
   d="scan'208";a="331214729"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 8 May 2012 21:37:24 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chase Douglas <chasedouglas@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr,
        benjamin.tissoires@gmail.com, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: MT - Include win8 support
Message-ID: <20120508193724.GA24034@polaris.bitmath.org>
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
 <4FA5889E.2030008@gmail.com>
 <4FA96AEF.4090106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA96AEF.4090106@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:50:23AM -0700, H. Peter Anvin wrote:
> On 05/05/2012 01:07 PM, Chase Douglas wrote:
> >>  
> >> +For devices capable of 360 degree orientation, the reported orientation
> >> +should be twice the given range.
> > 
> > I don't understand what this means. Can you elaborate?
> > 
> 
> A guess is that it means that the value is encoded as a single byte with
> a 2° granuarity?

Both Benjamin and Chase had the same question, and the reply is here:

http://www.spinics.net/lists/linux-input/msg20736.html

Hopefully that helps.

Thanks for chipping in,
Henrik
