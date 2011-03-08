Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1CHVCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1CHVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:02:54 -0500
Date: Tue, 8 Mar 2011 16:02:27 -0500
From: Dave Jones <davej@redhat.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v3] misc: adds support the FSA9480 USB Switch
Message-ID: <20110308210227.GA12804@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
	linux-i2c@vger.kernel.org, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
References: <4D75D338.9070801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D75D338.9070801@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 03:56:56PM +0900, Minkyu Kang wrote:

 > +static DEVICE_ATTR(switch, S_IRUGO | S_IWUGO,
 > +		fsa9480_show_manualsw, fsa9480_set_manualsw);
 
This probably shouldn't be world writable if it's writing to hardware.

	Dave

