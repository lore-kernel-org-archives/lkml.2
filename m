Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0FPQMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:12:09 -0400
Received: from n1-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.152]:47465 "HELO
	n1-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932109Ab0FPQMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:12:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 808020.84762.bm@omp201.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=uCCpm8HLO66BipDGDigb8D/lKDFPcEOUv0veJP0k5wGQgKkmaD6xvOf87GlL/jtZx2DgqrJMMqpenhymtTS7dRgdmiN5yYUSZg8vdRzmYxW1vGlyPuAuNulszgfzq0kH4cGzTn9h/I9ORXEUtTXctcDX2pO0f8d6T+pVMwffzPQ=;
Message-ID: <715635.32141.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: kbiTaZwVM1ng.cIrgm0mcb9uLqY1lzT_k5bv1AI0vyEx6fv
 BUT8gyKg53AgwwCafOJ8.8GlRXPKq9TClNxuXxeub4vHikQ7ToGRxLrlrMeZ
 uY7ghkC5.g88ABRfQPdu2AG4PDbXSK1Bn2j0Zq1W5WD0GtvVmgv_NP.nY.ER
 KPwah.34h8Gk9OgvYNgRc7S0Cj7LH8wsM5KNRXweImcw36NGGUaRHxQqD770
 bxiTcxPiD4edmz7NQ.2WH8vBeEOqOj2lLEgTgxARzX6t4qY5pqxI7zajbWkx
 uQIu4SZDN2YG8.LNh2uBGaPKIJpSzjBUZa4YVNlT_wgJ_3lo3qLMuFQ--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Wed, 16 Jun 2010 07:12:38 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv5 07/11] USB: gadget: g_ether: updated INF file
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9f32ae2ab133d27642ac4c1e81777b1e34a0c1a1.1276681840.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Updated the INF file for the g_ether
> gadegt.  It should work with most
> recent Windows systems now.  The file hase been also
> renamed to
> linux-rndis.inf rather then linux.inf.

NAK ... still waiting for a version of the
patch with all requested changes.  In
particular, without the rename (which
invalidates most documentation, though
it would otherwise be a reasonable cleanup).

