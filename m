Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1D3GWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 02:22:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41562 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1D3GWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 02:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JprQuLikYRfQD6OHHeAdzA4/vGjYwiZ4j/s0M1buVDNXvNVPTvSLrKDjyxyff3SB5n
         yTf6ktHE+Y4SFFxe0dlo5h5zrcA5naflXTmoaCfQ7IH1rOAOoyBwM3I8stFlRhmA2jTq
         XKoY2Cx6clsZG8w/mx3dt1BQc+wIG1b2l351k=
Date: Sat, 30 Apr 2011 14:22:24 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, randy.dunlap@oracle.com, greg@kroah.com,
        joe@perches.com, akpm@linux-foundation.org
Subject: [Oops 2/2]The frame size of xxx bytes is larger than 1024 bytes
Message-ID: <20110430062222.GB4274@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, trivial@kernel.org,
	randy.dunlap@oracle.com, greg@kroah.com, joe@perches.com,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
	A warning disturbs me for a long time.
It shows like following.

[...]
Warning: the frame size of xxx bytes is larger than 1024 bytes.
[...]

See http://s1202.photobucket.com/albums/bb364/harrywei/Kernel/?action=view&current=report_bug1.png for details.
	Of course, i wanna fix it. But i have no ways.
Can anyone do me a favor?

Thanks.
Harry Wei.
