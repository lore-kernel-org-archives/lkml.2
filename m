Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1DKPY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:24:28 -0400
Received: from nm16-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.253]:46994 "HELO
	nm16-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165Ab1DKPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:24:27 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 11:24:27 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 868144.28146.bm@omp1008.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=PpzQhod5cArOy6hEZ1av/JOvK1QDNjPcybeL4gsY3Bs94ptnbsiEs1CDCDiY0neiVM6rUnFQ3jIw37kEICVt32FmdVwk4g5focYjOB6Dblv3hEnxCOKmkG+ki4zdjT01CGUp4ROCmDfnEjas+mV0qdv+/Q+qI8m8pvFhLXMipRg=;
Message-ID: <779506.13049.qm@web161604.mail.bf1.yahoo.com>
X-YMail-OSG: NIWnV0AVM1lAX3fs.kSk2.fAy8phogZ9anEsSg2yjLNM0kA
 c9LKEADNJNAkFJ0mrpWdX3o1bbd.EMA8HZ6BrgtwaG0xTTVxmJHoV4ap5jjp
 e_owc4VQ0psv22VqTgTEWc432g6gQ0B2uk3f0z7YeTUlr6Cxy0SBX8TqlBUS
 45VAL6EhZiwFLGLu1gYGJJGzq.oDmcwKBq19WHT2AiQJdzA_XuYlE.55AzRc
 zg3rvbXMJlTEnSWpVKoVTjr.Q2dv5MKnvHdTkL3UKK6eGZ2qxoZ73nP_uX_t
 DgraRYhqqedOugv0RlkF6DNPU7227WCZA4q2Y0ECQTSUPZhHCaO0vw4xM8m4
 qkVKUHOoG.l7wtdo9E0XuXmfVfi31xvySpOwmQSzZe5pueBkuWI1zyUrK
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Mon, 11 Apr 2011 08:18:41 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
To: dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, gwingerde@gmail.com, xose.vazquez@gmail.com,
        ben@decadent.org.uk, users@rt2x00.serialmonkey.com,
        linux-wireless@vger.kernel.org, Shiang Tu <shiang_tu@ralinktech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update firmware for rt2800pci to Version 34 and firmware
> for rt2800usb to
> Version 29.

Are there any changelogs for these firmware files? Do they only offer support for newer chips, or are there any actual improvements and bug fixes implemented? Users should know whether updating the firmware will be of any use to them.

Walter 
