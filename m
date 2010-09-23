Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0IWOQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:16:51 -0400
Received: from core.signal11.us ([64.251.29.136]:35830 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab0IWOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:16:50 -0400
Cc: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-Id: <89BCFDE1-0D39-4248-84B2-E02C1480E067@signal11.us>
From: Alan Ott <alan@signal11.us>
To: Ville Tervo <ville.tervo@nokia.com>
In-Reply-To: <20100923115108.GC2379@null>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH v4 2/2] Bluetooth: hidp: Add support for hidraw  HIDIOCGFEATURE  and HIDIOCSFEATURE
Date: Thu, 23 Sep 2010 10:16:43 -0400
References: <1281442367.12579.206.camel@localhost.localdomain> <1281990059-3562-3-git-send-email-alan@signal11.us> <20100923115108.GC2379@null>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Sep 23 10:16:49 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c9b6151226781470313887
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23, 2010, at 7:51 AM, Ville Tervo wrote:

> Hi Alan,
>
> One comment.
>
> How about a variable called ret and using that to return len or  
> errno? It
> would eliminate code dublication.
>

Hi Ville,

Where specifically? In which function? I've gone through it a couple  
of times and failed to find return statements which are superfluous.  
Maybe I'm missing something fundamental?

Alan.


