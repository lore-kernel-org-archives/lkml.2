Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab1JFTZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:25:34 -0400
Received: from nm5-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.135]:41723 "HELO
	nm5-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756577Ab1JFTZd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:25:33 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 15:25:33 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 925522.44097.bm@omp1057.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yrVI83N6l+yMcPqtY1ca89OaxX6Pm3KFDtoY3EsKKsTVnnXk9oojfwqhEC68vHfyzPPbTc3gaKbpbuV7juzBpaeSfyNBxq6iJWFlJx84It/j4+lvCZLdqxV2cyPMvO9oMJcIlia1VwbONSU9rScgvkEFv1h0KNDZxx0K09Lim7g=;
X-YMail-OSG: PGB3TRcVM1kUx.Q8de1VfXUMf5uI4mh8.R8ccUWFJAbOdac
 mjAqBSoqcBWFjqgGjJHIK5vHan.cSeWZ2lsRp7nP1hdnfw1q6fG4XQTGS3aO
 qaFpyTRhX1on8zRikj.2GfEg0JesaBxGx9v5yfnJzrN2nMsNmMG3Kx6ddL8l
 P9QRnVk_Q7aLSL4hts2XagBW0iUJN72q9x1IOULPnLa8Kbv9PV3qly9b0Ufi
 RF.D2x5rs_e3hyshM76cNziWp8pQfhbFSSXgR1pajGNzSLCDbs9g.x64CKkY
 _pAOFY8Q57KlY7iuSGedZiHMaorrL4T_Zm6czuienbIg8tnrMa8Xwe78hANN
 8xzUB5Ole9xsio.nNomIhTiWdRZAKwrL6duQp_jC9CBrHbU9cEz11ANtlg8l
 0XhwIqDxJr_h7To2vjHO6jxwHVzZ5JdU55PMq.I3USL4.zvLAse1gxHkKMlJ
 G1kXUXfVDVR2dF30CYarDbBrrvxRm2uGXJuve0qT52_WxC93r2CTwKa0jlpf
 DNqnDKj7cgFI91vXTy9HSF2hLDAp58wvT8igaYDHkeQ--
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1317928788.76722.YahooMailNeo@web30301.mail.mud.yahoo.com>
Date: Thu, 6 Oct 2011 12:19:48 -0700 (PDT)
From: AW <arne_woerner@yahoo.com>
Reply-To: AW <arne_woerner@yahoo.com>
Subject: acm/ttyACM0/cdc_acm does not deliver data
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I made some USB devices using the CDC-ACM proposal...
They work fine with 2.6.38.8-35.fc15/amd64 and earlier.

But since 2.6.40-4.fc15/amd64 it doesnt work as before...


My device receives a byte and then echoes it...
Sometimes when the 65th byte is sent, a read(2) returns with 0...
When I close the device and open it again and send 1 byte, I receive the echo for the 65th byte...
(btw: after 65 bytes, the roles change: my self-tinkered device sends 65bytes and listens to the echoes...)
Funnily some 65-byte-sequences are always echoed as before, while some are not (I tried it at least 10 times; I think the "bad" sequences had a lot of zeroes...)...

On my headless Atom N270 I have 1 self-tinkered USB-ACM-device and 2 DVB-T USB sticks...
When I boot the 2.6.40 kernel it crashes after some minutes...

Can we change that somehow? *wag tail*
Is it safe to use 2.6.38.8-35 behind a NAT? (I mean: r there big security holes?)

PS: I reported it here https://bugzilla.redhat.com/show_bug.cgi?id=727610 , but fedora/redhat cant help me so much, because i m the only one who has that problem...

Thx.

Bye
Arne
