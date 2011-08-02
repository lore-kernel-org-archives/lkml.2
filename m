Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1HBKhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:37:51 -0400
Received: from nm19.bullet.mail.bf1.yahoo.com ([98.139.212.178]:28471 "HELO
	nm19.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753297Ab1HBKhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:37:34 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Aug 2011 06:37:34 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 113948.47238.bm@omp1033.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vwXdm46oAk2hwnQjDEQ2ec8kaE6s6cpvDCt/j4CG6+vywqwYkgdCvJepdtkvZSjDjHF61Cklpkqb9tLtTiXYbherLM9sAWhyw4iygyP6sAqQBvsmD5j+5KhoECbOrlIHB61nILm5sRcw6sJHkoqA1lYYySXr9nrYERd+kkG3neg=;
X-YMail-OSG: IAwpxzIVM1mh3Po36nA2P1sMaUhMwfwTp.Rjp324Tapmref
 tY1bQjtqNjIFVQYRs.4pXrD2V0LutMmSuZq.LgE68UI533usJhN7QWU3IRum
 A8y3v6KKk0bXL1cQVv.sgtkQjecrHgVSPlNvo0Znio6EAAhc1nLpxLI1fMEA
 W.FR0haaVq7BqQOuB9yP70ij_Dm_UajWWfqnJ29SY_TcsaDHX5nLO5gGjkCZ
 nh1z149TdilEEWFy.Wjbc8StP5bk50WvuGTsTtBqfHXC5gy_MUqw_.IwGyHE
 Dlw.OFAKl.ku6zMQS5iMPllVTCyIwMjqBphSC4nRhE1en8RWRgtLo1zOqCde
 5.ZDyeoWjDXUxXx7jyjQuERQhzETXKhxW1G9eER1x3GYf98Evf8oVCQ--
X-Mailer: YahooMailWebService/0.8.112.310352
Message-ID: <1312281101.75725.YahooMailNeo@web162015.mail.bf1.yahoo.com>
Date: Tue, 2 Aug 2011 03:31:41 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Relation between PFN and page block ?
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
 
I am trying to understand the relation between "Page Frame Number" and "Page Block".
Like how to find out if a particular page frame is associated with which page block.
 
I have looked into Documentation/vm/pagemap but could not understand the exact mapping.
 
Can somebody explain me in detail how page frame number and page block are related.
 
 
Thanks,
Pintu
