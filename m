Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab1JGIr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:47:29 -0400
Received: from nm10.bullet.mail.ac4.yahoo.com ([98.139.52.207]:31551 "HELO
	nm10.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758587Ab1JGIr2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:47:28 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Oct 2011 04:47:28 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 285815.98866.bm@omp1034.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BDam3V3I/2YgHkEv/bGNFwZzhLn0RbcFz7/sgq5JWDr3z41xF7lk3yOTHpMCoOja/ctrKB5gQVwiRVSu2g+yOgImJqW5MoK/DQxWtw7oFrySbVKjAHWlAAHju60R88K8wXxwaJ741CpgxD8ZHLDftzDU+hgbKeZKWKL8gOKzoOU=;
X-YMail-OSG: phBw8uIVM1lZTjuYD9VuIDfgg6R5hrfbbGCJLTRUOnm4DW8
 pSGhhwPDWKU98u3tz.yNuledH2764q3YEqFw9L3Qc8U.7uYz32scU0jMF6gs
 XEHtp2V0gMkLs8Bp2zEfahanYyJzrUqEVL7X4TC3YITvDrBTQYFzZBxwGdzj
 iBJaeEf_V42Quzz9t6GndlRglrheGYdwlPT09P1Oucf1nFCASSYAuKYJBB1Y
 rFZG6fukn3EeSa87pm1S7ckoCnNMxhlfZDofiEqv_p0626Cu8IrxBhP7FMd8
 9gi.YLfQ..y7.Fz3AdM5TplF7NBv.cAnXYoy2_IRpt29rcIsp.L.jb5h_7XE
 Y5tYK.UXUKMxyuRQiTlDMUeV1TMMymermify72tsq.JxZ8njsZMU8spBPhoe
 gye2Vmq39exRE4PFaon6l3NKk0e8Emzmq64wWKn7ldtKECIXD7y43J3Z.Vng
 SHQuoUR8DpGslR8K65Q8SDkdON1lEqEo.I5A69GmvpFm1WZiJYYPXpca_ODQ
 s4E12zafoMy4nq_71YKKfTrG8UmNotgUB5XNB2Xilbo.RY00sJMZwKnKEj82
 X9.6ORBFzLDFbUIstGBmCp7FZJJUWBnAS5tOFrzc-
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1317976819.47237.YahooMailNeo@web30304.mail.mud.yahoo.com>
Date: Fri, 7 Oct 2011 01:40:19 -0700 (PDT)
From: AW <arne_woerner@yahoo.com>
Reply-To: AW <arne_woerner@yahoo.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you try a kernel.org release instead of a Fedora kernel?
>
never tried that... can i just download a rpm and install it?

> If not, please post the output of running the usbmon [...]

>
I did that:
On the 2.6.38 kernel: each try works fine...
http://www.wgboome.org/cmd:Z-L-0,2.6.38.8-35.fc15.x86_64.usbmon

On the 2.6.40 kernel (=3.0.6?): both tries failed (but the 2nd try with slightly different beginning):
http://www.wgboome.org/cmd:Z-L-0,1st-try,2.6.40.6-0.fc15.x86_64.usbmon

http://www.wgboome.org/cmd:Z-L-0,2nd-try,2.6.40.6-0.fc15.x86_64.usbmon


-arne
