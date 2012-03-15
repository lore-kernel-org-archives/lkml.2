Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089Ab2COQ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:57:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161055Ab2COQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:57:44 -0400
Date: Thu, 15 Mar 2012 11:57:36 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Linux 3.0.24
Message-ID: <20120315165736.GA11496@burratino>
References: <20120312203451.GA16773@kroah.com>
 <20120315162322.GA26005@foursquare.net>
 <20120315163749.GA25001@kroah.com>
 <20120315165108.GA27737@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165108.GA27737@foursquare.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Frey wrote:

> Perhaps it would help if I phrased my question differently: What kind of
> bug makes you decide to write "must" instead of something else?

My impression is that Greg does not want to be in the business of
deciding which updates are security-critical.  Others can make that
judgement based on the patches listed.

"All users must upgrade" would generally mean that it is prudent for
all users to upgrade, rather than some particular subset of them
(e.g., users who have been experiencing build failures).

Hope that helps,
Jonathan
