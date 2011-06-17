Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1FQLC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:02:59 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:39284 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1FQLC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:02:56 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jun 2011 12:02:52 +0100
Subject: RE: kernel 2.6.39 iop-adma pq-zero-sum self-test failed
Thread-Topic: kernel 2.6.39 iop-adma pq-zero-sum self-test failed
Thread-Index: AcwrS8SoJkZKC4RWQACkNNMyHj+FpgBkdU3Q
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C77857977@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> iop-adma iop-adma.0: Intel(R) IOP: ( xor xor_val fill cpy intr )
> iop-adma iop-adma.1: Intel(R) IOP: ( xor xor_val fill cpy intr )
> iop-adma iop-adma.2: Self-test pq-zero-sum failed to validate: 1

This was with gcc 4.6.0.  Switching to gcc 4.4.2, the pq-zero-sum self-test
passes:

iop-adma iop-adma.0: Intel(R) IOP: ( xor xor_val fill cpy intr )
iop-adma iop-adma.1: Intel(R) IOP: ( xor xor_val fill cpy intr )
iop-adma iop-adma.2: Intel(R) IOP: ( pq pq_val xor xor_val fill cpy intr )


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
