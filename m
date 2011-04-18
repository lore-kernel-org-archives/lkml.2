Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1DRXDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:03:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1DRXDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:03:02 -0400
Date: Mon, 18 Apr 2011 19:02:55 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110418230254.GA22588@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com>
 <20110412192103.GA13278@redhat.com>
 <87tye1ckhr.fsf@linux.vnet.ibm.com>
 <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:57:27AM +0200, Kay Sievers wrote:

 > > uuid:<value> is the option field  as per
 > > Documentation/filesystem/proc.txt. There was an error in libmount
 > > parsing which got fixed upstream recently
 > 
 > Just a simple question about this approach in general? A filesystem
 > UUID can be changed on disk at any time (tune2fs -U ...).
 > 
 > Your code looks like you copy the bytes to the in-kernel superblock
 > structure without noticing any later changes on disk? How is that
 > supposed to work?

I thought tune2fs on a mounted filesystem was always a
"you get to keep both pieces if it breaks" situation.

	Dave

